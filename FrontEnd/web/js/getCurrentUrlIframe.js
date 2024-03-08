async function getCrtUrlElementByIdFun(iframeId ) {
const currentIframeHref = new URL(document.location.href);
const urlOrigin = currentIframeHref.origin;
const urlFilePath = decodeURIComponent(currentIframeHref.pathname);
console.log("iframe_id: " + iframeId );
  console.log("C Url :==> " + document.getElementById(iframeId ).contentWindow.location);
  console.log("C Url 1 :==> " + document.getElementById(iframeId ).contentDocument.referrer);
  console.log("C Url 2 :==> " +currentIframeHref);
  console.log("C Url 2 :==> " +urlOrigin);
  console.log("C Url 2 :==> " +urlFilePath);
  let promise = new Promise(function(resolve, reject) {
    resolve(document.getElementById(iframeId ).contentWindow.location.href);
  });
  let result = await promise;
  return result;
}