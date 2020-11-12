package main

import (
	"net/http"
)

func responseHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello from Kemal"))
}

func main() {

	http.HandleFunc("/", responseHandler)
	http.ListenAndServe(":11130", nil)

}
