ALB="enterprise-platform-1124446186.us-east-1.elb.amazonaws.com"

# 1. Frontend
echo "=== Frontend (/) ===" && \
curl -s -o /dev/null \
  -w "HTTP Status: %{http_code}\n" \
  http://$ALB/

# 2. Frontend health
echo "=== Frontend Health ===" && \
curl -s http://$ALB/health

# 3. Backend
echo "=== Backend (/api) ===" && \
curl -s -o /dev/null \
  -w "HTTP Status: %{http_code}\n" \
  http://$ALB/api/v1/info

# 4. API
echo "=== API (/v1) ===" && \
curl -s -o /dev/null \
  -w "HTTP Status: %{http_code}\n" \
  http://$ALB/v1/health

# 5. Full response from backend
echo "=== Backend Full Response ===" && \
curl -s http://$ALB/api/v1/info

# 6. Full response from api
echo "=== API Full Response ===" && \
curl -s http://$ALB/v1/health
