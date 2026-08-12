/* coi-serviceworker v0.1.7 - Guido Zuidhof and contributors, licensed under MIT */
/* https://github.com/gzuidhof/coi-serviceworker */
if (typeof window === 'undefined') {
  self.addEventListener("install", () => self.skipWaiting());
  self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));
  self.addEventListener("fetch", function (event) {
    if (event.request.cache === "only-if-cached" && event.request.mode !== "same-origin") {
      return;
    }
    event.respondWith(
      fetch(event.request).then(function (response) {
        if (response.status === 0) {
          return response;
        }
        const newHeaders = new Headers(response.headers);
        newHeaders.set("Cross-Origin-Opener-Policy", "same-origin");
        newHeaders.set("Cross-Origin-Embedder-Policy", "require-corp");
        return new Response(response.body, {
          status: response.status,
          statusText: response.statusText,
          headers: newHeaders,
        });
      }).catch(function (e) {
        console.error(e);
      })
    );
  });
} else {
  const reloadedBySW = new URLSearchParams(location.search).get("coi-serviceworker");
  if (reloadedBySW) {
    const url = new URL(location.href);
    url.searchParams.delete("coi-serviceworker");
    history.replaceState(null, null, url);
  }
  if ("serviceWorker" in navigator) {
    if (!window.crossOriginIsolated) {
      navigator.serviceWorker
        .register(document.currentScript.src)
        .then(function (registration) {
          if (!registration.active) {
            window.location.reload();
          } else {
            console.log("COI Service Worker already active");
          }
        })
        .catch(function (e) {
          console.error("COI Service Worker registration failed:", e);
        });
    }
  }
}
