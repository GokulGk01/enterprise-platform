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
	Service     string `json:"service"`
}

type InfoResponse struct {
	Service string `json:"service"`
	Version string `json:"version"`
}

func getEnv(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:      "healthy",
		Version:     getEnv("APP_VERSION", "1.0.0"),
		Environment: getEnv("ENVIRONMENT", "dev"),
		Service:     "api",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func infoHandler(w http.ResponseWriter, r *http.Request) {
	response := InfoResponse{
		Service: "api",
		Version: getEnv("APP_VERSION", "1.0.0"),
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func main() {
	port := getEnv("PORT", "9090")

	// Health check routes
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/v1/health", healthHandler)

	// Info routes
	http.HandleFunc("/v1/info", infoHandler)

	fmt.Printf("API server starting on port %s\n", port)
	http.ListenAndServe(":"+port, nil)
}
