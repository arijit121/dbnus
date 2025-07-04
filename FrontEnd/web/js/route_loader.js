document.addEventListener("DOMContentLoaded", function () {
    const loader = document.getElementById("web-initial-loader");

    function setLoader(file, replaceData = {}) {
        console.log(`Fetching loader: ${file}`, replaceData); // Debug log
        fetch(file)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.text();
            })
            .then(html => {
                if (loader) {
                    loader.innerHTML = html;
                    loader.style.display = "block";

                    // Replace dynamic content
                    for (let key in replaceData) {
                        const element = loader.querySelector(`#${key}`);
                        if (element) {
                            element.textContent = replaceData[key];
                        }
                    }
                }
            })
            .catch(error => console.error("Loader fetch failed:", error));
    }

    function handleRouteChange() {
        const path = window.location.pathname;
        console.log(`Route changed: ${path}`);

        if (path === "/" || path === "/index.html") {
            setLoader("design/default-loader.html");
        }
        // else if (path.startsWith("/path-parameter/")) {
        //     let value = path.split("/").pop().replace(/-/g, " ");
        //     setLoader("design/dynamic-loader.html", { "data": value });
        // }
        // else if (path.startsWith("/order-otc/")) {
        //     let otcParts = path.split("/").pop().split("-");
        //     let otcId = otcParts.pop();
        //     let otcName = otcParts.join(" ");
        //     setLoader("design/otc.html", { "otc-name": otcName });
        // }
        else {
            setLoader("design/dynamic-loader.html");
        }
    }

    // Intercept pushState & replaceState
    function patchHistoryMethod(type) {
        const original = history[type];
        history[type] = function () {
            const result = original.apply(this, arguments);
            const event = new Event(type.toLowerCase());
            window.dispatchEvent(event);
            return result;
        };
    }

    patchHistoryMethod("pushState");
    patchHistoryMethod("replaceState");

    window.addEventListener("popstate", handleRouteChange);
    window.addEventListener("pushstate", handleRouteChange);
    window.addEventListener("replacestate", handleRouteChange);

    // Initial load
    handleRouteChange();
});
