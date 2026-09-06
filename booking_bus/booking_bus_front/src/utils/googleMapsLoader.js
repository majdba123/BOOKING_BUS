let googleMapsPromise = null;

export function loadGoogleMaps() {
    if (window.google?.maps) {
        return Promise.resolve(window.google);
    }

    if (googleMapsPromise) {
        return googleMapsPromise;
    }

    const apiKey = process.env.VUE_APP_GOOGLE_MAPS_API_KEY;

    if (!apiKey) {
        return Promise.reject(
            new Error(
                "VUE_APP_GOOGLE_MAPS_API_KEY is required to load Google Maps."
            )
        );
    }

    googleMapsPromise = new Promise((resolve, reject) => {
        const existingScript = document.getElementById("google-maps-api");

        if (existingScript) {
            existingScript.addEventListener("load", () => resolve(window.google), {
                once: true,
            });
            existingScript.addEventListener(
                "error",
                () => reject(new Error("Failed to load Google Maps API.")),
                { once: true }
            );
            return;
        }

        const script = document.createElement("script");
        script.id = "google-maps-api";
        script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(
            apiKey
        )}&libraries=places,geometry`;
        script.async = true;
        script.defer = true;

        script.onload = () => resolve(window.google);
        script.onerror = () => {
            googleMapsPromise = null;
            reject(new Error("Failed to load Google Maps API."));
        };

        document.head.appendChild(script);
    });

    return googleMapsPromise;
}
