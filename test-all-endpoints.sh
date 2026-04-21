#!/bin/bash

# Microservice Actuator & API Testing Script
# This script tests all available endpoints

BASE_URL="http://localhost:9090"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        SPRING BOOT ACTUATOR & API ENDPOINT TESTER              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Function to print section headers
print_header() {
    echo ""
    echo "┌────────────────────────────────────────────────────────────┐"
    echo "│ $1"
    echo "└────────────────────────────────────────────────────────────┘"
    echo ""
}

# Function to make and display API calls
test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4

    echo "📌 $description"
    echo "   Method: $method"
    echo "   URL: $BASE_URL$endpoint"

    if [ -z "$data" ]; then
        echo "   Request:"
        curl -s -X $method "$BASE_URL$endpoint" | python3 -m json.tool 2>/dev/null || curl -s -X $method "$BASE_URL$endpoint"
    else
        echo "   Data: $data"
        curl -s -X $method "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data" | python3 -m json.tool 2>/dev/null || curl -s -X $method "$BASE_URL$endpoint" -H "Content-Type: application/json" -d "$data"
    fi
    echo ""
}

# Test connection
echo "Testing connection to $BASE_URL..."
if ! curl -s "$BASE_URL" > /dev/null 2>&1; then
    echo "❌ Cannot connect to $BASE_URL"
    echo "   Make sure the application is running on port 9090"
    echo "   Start it with: java -jar target/microservicerefresher-0.0.1-SNAPSHOT.jar --server.port=9090"
    exit 1
fi
echo "✅ Connected successfully!"
echo ""

# ============================================
# ACTUATOR ENDPOINTS
# ============================================

print_header "1️⃣  ACTUATOR - HEALTH CHECK"
test_endpoint "GET" "/actuator/health" "" "Application Health Status"

print_header "2️⃣  ACTUATOR - AVAILABLE METRICS"
test_endpoint "GET" "/actuator/metrics" "" "List All Available Metrics"

print_header "3️⃣  ACTUATOR - APPLICATION INFO"
test_endpoint "GET" "/actuator/info" "" "Application Information"

print_header "4️⃣  ACTUATOR - ENVIRONMENT PROPERTIES"
test_endpoint "GET" "/actuator/env" "" "Environment & Configuration Properties"

# ============================================
# EMPLOYEE API ENDPOINTS
# ============================================

print_header "5️⃣  EMPLOYEE API - GET ALL EMPLOYEES"
test_endpoint "GET" "/api/employees" "" "Retrieve All Employees"

print_header "6️⃣  EMPLOYEE API - CREATE NEW EMPLOYEE"
test_endpoint "POST" "/api/employees" \
    '{"name":"Alice Johnson","email":"alice@example.com","department":"Engineering"}' \
    "Create a New Employee"

print_header "7️⃣  EMPLOYEE API - GET EMPLOYEE BY ID"
test_endpoint "GET" "/api/employees/1" "" "Get Employee with ID=1"

# ============================================
# DOCUMENTATION
# ============================================

print_header "📚 API DOCUMENTATION"
echo "📖 OpenAPI/Swagger UI: $BASE_URL/swagger-ui.html"
echo ""
echo "Open this URL in your browser to:"
echo "  ✓ View all API endpoints"
echo "  ✓ See request/response examples"
echo "  ✓ Test endpoints interactively"
echo ""

# ============================================
# SUMMARY
# ============================================

print_header "✨ TEST SUMMARY"
echo "✅ Actuator Endpoints:"
echo "   • /actuator/health - Application health status"
echo "   • /actuator/metrics - Performance metrics"
echo "   • /actuator/info - Application information"
echo "   • /actuator/env - Configuration properties"
echo ""
echo "✅ Employee API Endpoints:"
echo "   • GET    /api/employees - Get all employees"
echo "   • POST   /api/employees - Create employee"
echo "   • GET    /api/employees/{id} - Get by ID"
echo "   • PUT    /api/employees/{id} - Update employee"
echo "   • DELETE /api/employees/{id} - Delete employee"
echo ""
echo "✅ Testing complete!"
echo ""

