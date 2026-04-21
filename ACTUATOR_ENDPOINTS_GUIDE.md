# Spring Boot Actuator - Endpoints Guide

## Application Details
- **Application Name**: microservicerefresher
- **Version**: 0.0.1-SNAPSHOT
- **Spring Boot Version**: 4.0.3
- **Port**: 9090 (configured when needed)
- **Base URL**: `http://localhost:9090`

---

## Prerequisites ✅

To use the Actuator endpoints, the following are already configured:

1. **Dependency Added** (in `pom.xml`)
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-actuator</artifactId>
   </dependency>
   ```

2. **Configuration Added** (in `application.properties`)
   ```properties
   # Actuator configuration
   management.endpoints.web.exposure.include=health,metrics,info,env
   management.endpoint.health.show-details=always
   ```

3. **Application Running**
   ```bash
   java -jar target/microservicerefresher-0.0.1-SNAPSHOT.jar --server.port=9090
   ```

---

## Available Actuator Endpoints

### 1. **Health Check** ✅
**Endpoint**: `GET /actuator/health`

**Purpose**: Check if the application and its components are running properly.

**Example Request**:
```bash
curl -s http://localhost:9090/actuator/health | python3 -m json.tool
```

**Example Response**:
```json
{
    "components": {
        "db": {
            "details": {
                "database": "MySQL",
                "validationQuery": "isValid()"
            },
            "status": "UP"
        },
        "diskSpace": {
            "details": {
                "total": 245107195904,
                "free": 48465575936,
                "threshold": 10485760,
                "path": "/Users/binurajek/Documents/WORKSPACE/JAVA/microservicerefresher/.",
                "exists": true
            },
            "status": "UP"
        },
        "livenessState": {
            "status": "UP"
        },
        "ping": {
            "status": "UP"
        },
        "readinessState": {
            "status": "UP"
        },
        "ssl": {
            "details": {
                "expiringChains": [],
                "invalidChains": [],
                "validChains": []
            },
            "status": "UP"
        }
    },
    "groups": ["liveness", "readiness"],
    "status": "UP"
}
```

**What it shows**:
- ✅ **Database (db)**: MySQL connection status
- ✅ **Disk Space**: Available storage
- ✅ **Liveness State**: Is the app alive?
- ✅ **Ping**: Simple health check
- ✅ **Readiness State**: Is the app ready to receive requests?
- ✅ **SSL**: Certificate status

---

### 2. **Available Metrics** 📊
**Endpoint**: `GET /actuator/metrics`

**Purpose**: List all available metrics that can be monitored.

**Example Request**:
```bash
curl -s http://localhost:9090/actuator/metrics | python3 -m json.tool
```

**Available Metrics Include**:
- `application.ready.time` - Time taken for app to be ready
- `application.started.time` - Time taken for app to start
- `disk.free` - Free disk space
- `disk.total` - Total disk space
- `hikaricp.connections.*` - Database connection pool metrics
- `http.server.requests` - HTTP request metrics
- `jvm.*` - JVM metrics (memory, GC, threads, etc.)
- `system.*` - System metrics (CPU, memory, etc.)

---

### 3. **Specific Metric Details** 📈
**Endpoint**: `GET /actuator/metrics/{metric-name}`

**Purpose**: Get detailed information about a specific metric.

**Example Requests**:
```bash
# Get HTTP server requests
curl -s http://localhost:9090/actuator/metrics/http.server.requests | python3 -m json.tool

# Get JVM memory metrics
curl -s http://localhost:9090/actuator/metrics/jvm.memory.used | python3 -m json.tool

# Get disk space information
curl -s http://localhost:9090/actuator/metrics/disk.free | python3 -m json.tool
```

---

### 4. **Application Info** ℹ️
**Endpoint**: `GET /actuator/info`

**Purpose**: Display application information (name, version, description, etc.).

**Example Request**:
```bash
curl -s http://localhost:9090/actuator/info | python3 -m json.tool
```

**Current Response** (empty by default):
```json
{}
```

**To add custom info**, add to `application.properties`:
```properties
app.name=Employee Management Microservice
app.version=0.0.1
app.description=A microservice for managing employees
```

Then access it via the endpoint.

---

### 5. **Environment Properties** 🔧
**Endpoint**: `GET /actuator/env`

**Purpose**: View all application environment properties and configurations.

**Example Request**:
```bash
curl -s http://localhost:9090/actuator/env | python3 -m json.tool
```

**What it shows**:
- Database connection details
- System properties
- Environment variables
- Application configuration properties

---

## Employee API Endpoints (Business Logic)

### 1. **Get All Employees**
```bash
GET http://localhost:9090/api/employees
```

### 2. **Get Employee by ID**
```bash
GET http://localhost:9090/api/employees/{id}
```

### 3. **Create Employee**
```bash
POST http://localhost:9090/api/employees
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "department": "Engineering"
}
```

### 4. **Update Employee**
```bash
PUT http://localhost:9090/api/employees/{id}
Content-Type: application/json

{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "department": "HR"
}
```

### 5. **Delete Employee**
```bash
DELETE http://localhost:9090/api/employees/{id}
```

---

## API Documentation

**Swagger UI**: `http://localhost:9090/swagger-ui.html`

Open this in your browser to see interactive API documentation and test endpoints.

---

## How to Test Endpoints Using Different Tools

### Using cURL (Command Line)
```bash
# Health check
curl -s http://localhost:9090/actuator/health | python3 -m json.tool

# Metrics
curl -s http://localhost:9090/actuator/metrics

# Create employee
curl -X POST http://localhost:9090/api/employees \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@test.com","department":"IT"}'
```

### Using Postman
1. Open Postman
2. Create a new request
3. Select method (GET, POST, etc.)
4. Enter URL: `http://localhost:9090/actuator/health`
5. Click "Send"

### Using Browser
1. Simply visit: `http://localhost:9090/actuator/health`
2. Or use the Swagger UI: `http://localhost:9090/swagger-ui.html`

### Using VS Code REST Client Extension
Create a `.rest` or `.http` file:
```
### Get Health
GET http://localhost:9090/actuator/health

### Get Metrics
GET http://localhost:9090/actuator/metrics

### Get All Employees
GET http://localhost:9090/api/employees
```

---

## Common Issues & Solutions

### Issue: 404 Not Found on /actuator/health
**Solution**: 
- Ensure application is running on the correct port
- Check if Actuator dependency is added to `pom.xml`
- Verify `application.properties` has the correct configuration
- Rebuild the project: `./mvnw clean install`

### Issue: Port Already in Use
**Solution**:
```bash
# Kill process on port 9090
lsof -i :9090 | grep -v COMMAND | awk '{print $2}' | xargs kill -9

# Or start on different port
java -jar target/microservicerefresher-0.0.1-SNAPSHOT.jar --server.port=8081
```

### Issue: Database Connection Failed
**Solution**:
- Ensure MySQL is running on localhost:3306
- Verify database credentials in `application.properties`
- Check if `microservicedb` database exists

---

## Key Takeaways

✅ **Just Application Start is NOT Enough**

To access health endpoints, you need:
1. ✅ Spring Boot Actuator dependency
2. ✅ Actuator configuration in properties
3. ✅ Application running
4. ✅ HTTP client to make requests
5. ✅ Correct port and URL

**Formula**: Dependency + Configuration + Running App + HTTP Request = Working Endpoints

---

## Next Steps

1. Start the application: `java -jar target/microservicerefresher-0.0.1-SNAPSHOT.jar`
2. Open Swagger UI: `http://localhost:9090/swagger-ui.html`
3. Test health endpoint: `http://localhost:9090/actuator/health`
4. Monitor metrics as needed
5. Use in production for health checks and monitoring

---

**Created**: April 7, 2026
**Version**: 1.0

