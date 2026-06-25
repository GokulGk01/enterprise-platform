# Simple Flask API for testing
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'version': os.getenv('APP_VERSION', '1.0.0'),
        'environment': os.getenv('ENVIRONMENT', 'dev')
    })

@app.route('/api/v1/info')
def info():
    return jsonify({
        'service': 'backend',
        'version': os.getenv('APP_VERSION', '1.0.0')
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)