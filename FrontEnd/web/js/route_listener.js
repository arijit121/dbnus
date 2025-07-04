document.addEventListener("DOMContentLoaded", function () {
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
                container.innerHTML = html;
                container.style.display = "block";

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

        let descTag = document.querySelector('meta[name="description"]');
        if (!descTag) {
            descTag = document.createElement('meta');
            descTag.setAttribute('name', 'description');
            document.head.appendChild(descTag);
        }
        descTag.setAttribute('content', description || '');

        if (tag) {
            let tagMeta = document.querySelector('meta[name="tags"]');
            if (!tagMeta) {
                tagMeta = document.createElement('meta');
                tagMeta.setAttribute('name', 'tags');
                document.head.appendChild(tagMeta);
            }
            tagMeta.setAttribute('content', tag);
        }
    }

    function handleRouteChange() {
        const path = window.location.pathname;
        console.log(`Route changed: ${path}`);

        if (path === "/" || path === "/index.html") {
            setData({ containerId: "web-loader", file: "design/default-loader.html" });
            // setData({ containerId: "web-seo-content", file: "design/seo-content-default.html" });
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
