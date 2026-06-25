package main

import (
    "encoding/json"
    "fmt"
    "net/http"
    "os"
)

type HealthResponse struct {
    Status      string `json:"status"`
    Version     string `json:"version"`
    Environment string `json:"environment"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    response := HealthResponse{
        Status:      "healthy",
        Version:     getEnv("APP_VERSION", "1.0.0"),
        Environment: getEnv("ENVIRONMENT", "dev"),
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}

func getEnv(key, defaultVal string) string {
    if val := os.Getenv(key); val != "" {
        return val
    }
    return defaultVal
}

func main() {
    port := getEnv("PORT", "9090")
    http.HandleFunc("/health", healthHandler)
    fmt.Printf("API server starting on port %s\n", port)
    http.ListenAndServe(":"+port, nil)
}