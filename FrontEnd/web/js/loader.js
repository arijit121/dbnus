document.addEventListener("DOMContentLoaded", function () {
    var path = window.location.pathname;
    var loader = document.getElementById("web-initial-loader");

    function setLoader(file, replaceData = {}) {
        console.log(`Fetching loader: ${file}`, replaceData); // Debugging log
        fetch(file)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.text();
            })
            .then(html => {
                if (loader) {
                    loader.innerHTML = html;
                    loader.style.display = "block";

                    // Replace dynamic content
                    for (let key in replaceData) {
                        let element = loader.querySelector(`#${key}`);
                        if (element) {
                            element.textContent = replaceData[key];
                        }
                    }
                }
            })
            .catch(error => console.error("Loader fetch failed:", error));
    }

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
        setLoader("design/default-loader.html");
    }
});
