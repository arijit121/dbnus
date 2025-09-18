document.addEventListener("DOMContentLoaded", function () {

    let historyPatched = "";
    let routeHistory = JSON.parse(sessionStorage.getItem('routeHistory') || "[]");

    function saveHistory() {
        // ✅ Keep only the last 20 routes
        if (routeHistory.length > 20) {
            routeHistory = routeHistory.slice(-20);
        }
        sessionStorage.setItem("routeHistory", JSON.stringify(routeHistory));
    }

    // ✅ Ensure current path is always in history (no duplicate at the end)
    const currentPath = window.location.pathname;

    if (routeHistory.length === 0 || routeHistory[routeHistory.length - 1] !== currentPath) {
        routeHistory.push(currentPath);
        saveHistory();
    }

    // Generalized data setter for any container
    function setData({ containerId, file, replaceData = {} }) {
        const container = document.getElementById(containerId);
        if (!container) {
            console.warn(`Container with ID '${containerId}' not found.`);
            return;
        }

        console.log(`Fetching ${file} into #${containerId}`, replaceData);

        fetch(file)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.text();
            })
            .then(html => {

                if (containerId === "web-seo-content") {
                    const doc = new DOMParser().parseFromString(html, "text/html");
                    
                    // Use <body>'s content for display
                    container.innerHTML = doc.body.innerHTML;
                    container.style.display = "block";
                    
                    injectStructuredDataFromHTML(html);
                    injectMetaTagsFromHTML(html);
                } else {
                    container.innerHTML = html;
                    container.style.display = "block";
                }

                // Replace dynamic content within that container
                for (let key in replaceData) {
                    const el = container.querySelector(`#${key}`);
                    if (el) el.textContent = replaceData[key];
                }
            })
            .catch(error => console.error(`Fetch failed for ${file}:`, error));
    }

    // Optional: set dynamic meta tags
    function setMetaTags({ title, description, tag }) {
        if (title) document.title = title;

        setOrCreateMeta("description", description);
        setOrCreateMeta("keywords", tag);
    }

    function setOrCreateMeta(name, content) {
        if (!name) return;
        let meta = document.querySelector(`meta[name="${name}"]`);
        if (!meta) {
            meta = document.createElement("meta");
            meta.setAttribute("name", name);
            document.head.appendChild(meta);
        }
        meta.setAttribute("content", content || "");
    }

    function injectStructuredDataFromHTML(html) {
        const doc = new DOMParser().parseFromString(html, "text/html");
        const ldJsonScript = doc.querySelector('script[type="application/ld+json"]');

        if (ldJsonScript) {
            try {
                const json = JSON.parse(ldJsonScript.textContent);
                setStructuredData(json);
            } catch (err) {
                console.error("Invalid JSON-LD format:", err);
            }
        }
    }

    function setStructuredData(json) {
        // Always remove existing JSON-LD blocks
        document.querySelectorAll('script[type="application/ld+json"]').forEach(s => s.remove());

        // Check if the passed JSON is not empty
        if (json && Object.keys(json).length > 0) {
            const script = document.createElement("script");
            script.type = "application/ld+json";
            script.textContent = JSON.stringify(json);
            document.head.appendChild(script);
        } else {
            console.log("Structured data cleared (empty object provided)");
        }
    }

    function injectMetaTagsFromHTML(html) {
        const doc = new DOMParser().parseFromString(html, "text/html");

        const title = doc.querySelector("title")?.textContent || "";
        const description = doc.querySelector('meta[name="description"]')?.content || "";
        const keywords = doc.querySelector('meta[name="keywords"]')?.content || "";

        setMetaTags({ title: title,description: description, tag: keywords });
    }

    function handleRouteChange(event) {

        const path = window.location.pathname;

        if (path === historyPatched) {
            return;
        }
        historyPatched = path;
        // console.log(`Route changed: ${historyPatched}`);
        routeHistory = JSON.parse(sessionStorage.getItem('routeHistory') || "[]");
        // ✅ Manage routeHistory
        if (event && event.type === "popstate") {
            routeHistory.pop(); // Back navigation
        } else {
            // Forward navigation
            if (routeHistory.length === 0 || routeHistory[routeHistory.length - 1] !== path) {
                routeHistory.push(path); // Add only if different
            }
        }
        saveHistory();

        const loader = document.getElementById("web-loader");
        if (loader) {
            loader.style.display = "none";
            loader.innerHTML = ""; // Clear previous content
        }

        const seoContent = document.getElementById("web-seo-content");
        if (seoContent) {
            seoContent.style.display = "none";
            seoContent.innerHTML = ""; // Clear previous content
        }

        if (path === "/" || path === "/index.html") {
            setData({ containerId: "web-loader", file: "design/default-loader.html" });
            // setData({ containerId: "web-seo-content", file: "design/dynamic-loader.html" });
        }
        else if (path === "/bio-data") {
            setData({ containerId: "web-loader", file: "design/bio-data-loader.html" });
            // setData({ containerId: "web-seo-content", file: "design/dynamic-loader.html" });
        }
        // else if (path.startsWith("/path-parameter/")) {
        //     let value = path.split("/").pop().replace(/-/g, " ");
        //     setData({ containerId: "web-loader", file: "design/dynamic-loader.html", replaceData: { "data": value } });
        //     setData({ containerId: "web-seo-content", file: "design/dynamic-loader.html", replaceData: { "data": value } });
        // }
        // else if (path.startsWith("/order-otc/")) {
        //     let otcParts = path.split("/").pop().split("-");
        //     let otcId = otcParts.pop();
        //     let otcName = otcParts.join(" ");
        //     setData({ containerId: "web-loader", file: "design/otc.html", replaceData: { "otc-name": otcName } });
        //     setData({ containerId: "web-seo-content", file: "design/seo-content-otc.html", replaceData: { "otc-name": otcName } });
        //     setMetaTags({
        //                     title: `Buy ${otcName} Online at the Best Price | SastaSundar`,
        //                     description: `Get ${otcName} online at discounted rates from SastaSundar. Learn about its benefits, ingredients, and usage.`,
        //                     tag: otcName
        //                  });
        // }
        else {
            setData({ containerId: "web-loader", file: "design/dynamic-loader.html" });
            // setData({ containerId: "web-seo-content", file: "design/seo-content-dynamic.html" });
            // setStructuredData({});
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
