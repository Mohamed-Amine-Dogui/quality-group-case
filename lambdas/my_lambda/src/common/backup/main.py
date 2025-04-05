import os
import urllib.parse
import base64

def lambda_handler(event, context):
    print("EVENT:", event)

    method = event.get("httpMethod")
    path = event.get("path")

    if method == "GET" and path == "/":
        return serve_html()

    if method == "POST" and path == "/index":
        return handle_form_submission(event)

    return {
        "statusCode": 404,
        "headers": {"Content-Type": "text/plain"},
        "body": "Not Found"
    }

def serve_html():
    index_path = os.path.join(os.path.dirname(__file__), "index.html")
    try:
        with open(index_path, "r", encoding="utf-8") as f:
            html = f.read()
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "text/html"},
            "body": html
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "text/plain"},
            "body": f"Error loading HTML: {str(e)}"
        }

def handle_form_submission(event):
    body = event.get("body", "")
    if event.get("isBase64Encoded", False):
        body = base64.b64decode(body).decode("utf-8")

    parsed = urllib.parse.parse_qs(body)
    username = parsed.get("username", [""])[0]
    password = parsed.get("password", [""])[0]

    print(f"Login submitted: username={username}, password={password}")

    html = f"""
    <html>
        <head><title>Login Result</title></head>
        <body>
            <h2>Login received</h2>
            <p>Username: {username}</p>
            <p>Password: {password}</p>
        </body>
    </html>
    """

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "text/html"},
        "body": html
    }
