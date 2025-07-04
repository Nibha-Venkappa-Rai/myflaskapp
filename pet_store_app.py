from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

# Data for the pet store
DOG_BREEDS = [
    {"breed": "Golden Retriever", "price": 10000},
    {"breed": "Labrador", "price": 5000},
    {"breed": "German Shepherd", "price": 15000},
    {"breed": "Siberian Husky", "price": 25000},
]

CAT_BREEDS = [
    {"breed": "Persian Cat", "price": 10000},
    {"breed": "Ragdoll", "price": 15000},
    {"breed": "Maine Coon", "price": 20000},
    {"breed": "Siamese Cat", "price": 10000},
]

# Welcome page
@app.route("/")
def welcome():
    return render_template_string("""
        <h1>Welcome to the Pet Store!</h1>
        <p>We sell cats and dogs. Visit <a href='/api/dogs'>/api/dogs</a> or <a href='/api/cats'>/api/cats</a> to see available breeds.</p>
    """)

# Health check endpoint
@app.route("/health")
def health_check():
    return jsonify({"status": "ok"}), 200

# Store access with health check
@app.before_request
def check_health():
    from flask import request
    if request.path.startswith("/api/"):
        # Simulate a health check before accessing the store
        # In a real app, you might check DB, etc.
        health = True  # Always healthy for this demo
        if not health:
            return jsonify({"error": "Store is currently unavailable"}), 503

# API endpoint for dogs
@app.route("/api/dogs")
def get_dogs():
    return jsonify({"dogs": DOG_BREEDS})

# API endpoint for cats
@app.route("/api/cats")
def get_cats():
    return jsonify({"cats": CAT_BREEDS})

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)