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

func getEnv(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}

func main() {
	port := getEnv("PORT", "9090")

	# Register ALL route variations
	http.HandleFunc("/health", healthHandler)
	# Direct health check

	http.HandleFunc("/v1/health", healthHandler)
	# ALB routes /v1/* here

	http.HandleFunc("/v1/info", func(w http.ResponseWriter, r *http.Request) {
		response := map[string]string{
			"service": "api",
			"version": getEnv("APP_VERSION", "1.0.0"),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	})

	fmt.Printf("API server starting on port %s\n", port)
	http.ListenAndServe(":"+port, nil)
}
