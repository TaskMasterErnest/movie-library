import uuid
import datetime
import functools

from flask import (
    Blueprint,
    app, 
    current_app,
    render_template, 
    session, 
    redirect, 
    request, 
    url_for,
    abort,
    flash,
    Response
)
from dataclasses import asdict
from prometheus_client import generate_latest

from movie_library.forms import (
    MovieForm, 
    ExtendedMovieForm, 
    SignUpForm, 
    LoginForm
)
from movie_library.models import Movie, User
from passlib.hash import pbkdf2_sha256
from string import punctuation
from string import printable
import stringprep


pages = Blueprint(
    "pages", __name__, template_folder="templates", static_folder="static"
)

def saslprep(password):
    return ''.join(char for char in password if not stringprep.in_table_c12(char))

def login_required(route):
    @functools.wraps(route)
    def route_wrapper(*args, **kwargs):
        if session.get("email") is None:
            return redirect(url_for(".login"))

        return route(*args, **kwargs)

    return route_wrapper


@pages.route("/")
@login_required
def index():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/').inc()

    current_app.logger.info(f"Fetching user data for email: {session['email']}")
    user_data = current_app.db.user.find_one({"email": session["email"]})

    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('find', 'user').inc()

    current_app.logger.info(f"User data fetched: {user_data}")
    user = User(**user_data)

    current_app.logger.info("Fetching movie data...")
    movie_data = current_app.db.movie.find({"_id": {"$in": user.movies}})

    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('find', 'movie').inc()

    movies = [Movie(**movie) for movie in movie_data]
    return render_template(
        "index.html",
        title="Movies Watchlist",
        movies_data=movies
    )


@pages.route("/signup", methods=["GET", "POST"])
def signUp():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels(request.method, '/signup').inc()

    current_app.logger.info("Accessing the signup route")
    if session.get("Email"):
        current_app.logger.info("User already logged in, redirecting to index")
        return redirect(url_for(".index"))
    
    form = SignUpForm()

    if form.validate_on_submit():
        current_app.logger.info(f"Form validated, creating user with email: {form.email.data}")

        # Sanitize password before hashing
        raw_password = form.password.data
        sanitized_password = saslprep(raw_password)

        user = User(
            _id=uuid.uuid4().hex,
            email=form.email.data,
            password=pbkdf2_sha256.hash(sanitized_password),
        )

        # Increment the database operation counter
        current_app.config['db_operation_total'].labels('insert', 'user').inc()

        current_app.db.user.insert_one(asdict(user))
        current_app.logger.info("User registered successfully")

        flash("User registered successfully", "success")

        return redirect(url_for(".login"))

    current_app.logger.info("Rendering the signup form")
    return render_template("signup.html", title="WatchList - SignUp", form=form)


@pages.route("/login", methods=["GET", "POST"])
def login():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels(request.method, '/login').inc()

    current_app.logger.info("Accessing the login route")
    if session.get("email"):
        current_app.logger.info("User already logged in, redirecting to index")
        return redirect(url_for(".index"))

    form = LoginForm()

    if form.validate_on_submit():
        current_app.logger.info(f"Form validated, fetching user data for email: {form.email.data}")

        # Increment the database operation counter
        current_app.config['db_operation_total'].labels('find', 'user').inc()

        user_data = current_app.db.user.find_one({"email": form.email.data})
        if not user_data:
            current_app.logger.warning("User data not found, login credentials not correct")

            # Increment the failed logins counter
            current_app.config['failed_logins_total'].inc()

            flash("Login credentials not correct", category="danger")
            return redirect(url_for(".login"))
        current_app.logger.info("User data fetched, verifying password")
        user = User(**user_data)

        if user and pbkdf2_sha256.verify(form.password.data, user.password):
            current_app.logger.info("Password verified, user logged in successfully")
            session["user_id"] = user._id
            session["email"] = user.email

            # Increment the active users gauge
            current_app.config['active_users'].inc()

            return redirect(url_for(".index"))

        current_app.logger.warning("Password verification failed, login credentials not correct")

        # Increment the failed logins counter
        current_app.config['failed_logins_total'].inc()

        flash("Login credentials not correct", category="danger")

    current_app.logger.info("Rendering the login form")
    return render_template("login.html", title="Watchlist - LogIn", form=form)


@pages.route("/logout")
def logout():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/logout').inc()

    current_theme = session.get("theme")
    # session.clear()
    del session["user_id"]
    del session["email"]
    session["theme"] = current_theme

    # Decrement the active users gauge
    current_app.config['active_users'].dec()

    return redirect(url_for(".login"))


@pages.route("/add", methods=["GET", "POST"])
@login_required
def add_movie():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels(request.method, '/add').inc()

    current_app.logger.info("Accessing the add_movie route")
    form = MovieForm()

    if form.validate_on_submit():
        current_app.logger.info(f"Form validated, creating movie with title: {form.title.data}")
        movie = Movie(
            _id = uuid.uuid4().hex,
            title = form.title.data,
            director = form.director.data,
            year = form.year.data
        )

        # Increment the database operation counter
        current_app.config['db_operation_total'].labels('insert', 'movie').inc()

        # insert into database
        current_app.logger.info("Inserting movie into database")
        current_app.db.movie.insert_one(asdict(movie))

        # Increment the database operation counter
        current_app.config['db_operation_total'].labels('update', 'user').inc()

        current_app.logger.info("Updating user's movie list in database")
        current_app.db.user.update_one(
        {"_id": session["user_id"]}, 
        {"$push": {"movies": movie._id}}
        )

        current_app.logger.info("Movie added successfully, redirecting to index")
        return redirect(url_for(".index"))
        # return redirect(url_for(".movie", _id=movie._id))   

    current_app.logger.info("Rendering the add_movie form")
    return render_template (
        "new_movie.html",
        title = "WatchList - Add Movie",
        form = form
    )


@pages.get("/movie/<string:_id>")
def movie(_id: str):
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/movie/<string:_id>').inc()

    current_app.logger.info(f"Accessing the movie route for movie id: {_id}")

    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('find', 'movie').inc()

    movie_data = current_app.db.movie.find_one({"_id": _id})
    if not movie_data:
        current_app.logger.warning(f"No movie found for id: {_id}, aborting with 404")
        abort(404)
    current_app.logger.info(f"Movie data fetched for id: {_id}")
    movie = Movie(**movie_data)
    current_app.logger.info("Rendering the movie_details template")
    return render_template("movie_details.html", movie=movie)


@pages.get("/movie/<string:_id>/rate")
@login_required
def rate_movie(_id):
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/movie/<string:_id>/rate').inc()

    current_app.logger.info(f"Accessing the rate_movie route for movie id: {_id}")
    rating = int(request.args.get("rating"))
    current_app.logger.info(f"Rating received: {rating}")

    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('update', 'movie').inc()

    current_app.db.movie.update_one({"_id": _id}, {"$set": {"rating": rating}})

    # Increment the movies rated counter
    current_app.config['movies_rated_total'].inc()

    current_app.logger.info("Movie rating updated in database")

    return redirect(url_for(".movie", _id=_id))


@pages.get("/movie/<string:_id>/watch")
@login_required
def watch_today(_id):
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/movie/<string:_id>/watch').inc()

    current_app.logger.info(f"Accessing the watch_today route for movie id: {_id}")
    
    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('update', 'movie').inc()
    
    current_app.db.movie.update_one(
        {"_id": _id}, {"$set": {"last_watched": datetime.datetime.today()}}
    )

    # Increment the movies watched counter
    current_app.config['movies_watched_total'].inc()

    current_app.logger.info("Movie last_watched date updated in database")
    return redirect(url_for(".movie", _id=_id))


@pages.route("/edit/<string:_id>", methods=["GET", "POST"])
@login_required
def edit_movie(_id: str):
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels(request.method, '/edit/<string:_id>').inc()

    current_app.logger.info(f"Accessing the edit_movie route for movie id: {_id}")
    
    # Increment the database operation counter
    current_app.config['db_operation_total'].labels('find', 'movie').inc()

    movie = Movie(**current_app.db.movie.find_one({"_id": _id}))
    form = ExtendedMovieForm(obj=movie)
    if form.validate_on_submit():
        current_app.logger.info(f"Form validated, updating movie with id: {_id}")
        movie.title = form.title.data
        movie.director = form.director.data
        movie.year = form.year.data
        movie.cast = form.cast.data
        movie.series = form.series.data
        movie.tags = form.tags.data
        movie.description = form.description.data
        movie.video_link = form.video_link.data

        # Increment the database operation counter
        current_app.config['db_operation_total'].labels('update', 'movie').inc()

        current_app.db.movie.update_one({"_id": movie._id}, {"$set": asdict(movie)})
        current_app.logger.info("Movie updated in database")
        return redirect(url_for(".movie", _id=movie._id))
    current_app.logger.info("Rendering the edit_movie form")
    return render_template("movie_form.html", movie=movie, form=form)



@pages.get("/toggle-theme")
def toggle_theme():
    # Increment the HTTP request counter
    current_app.config['http_requests_total'].labels('get', '/toggle-theme').inc()

    current_theme = session.get("theme")
    if current_theme == "dark":
        session["theme"] = "light"
    else:
        session["theme"] = "dark"
    
    # Increment the theme changes counter
    current_app.config['theme_changes_total'].inc()

    return redirect(request.args.get("current_page"))


@pages.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')