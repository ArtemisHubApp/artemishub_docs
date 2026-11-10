/* Artemis docs: revela seções da landing ao rolar a página */
(function () {
  var root = document.documentElement;
  var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (reduce || !("IntersectionObserver" in window)) return;
  root.classList.add("art-js");
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) { e.target.classList.add("is-in"); io.unobserve(e.target); }
    });
  }, { threshold: 0.12, rootMargin: "0px 0px -40px 0px" });
  function arm() {
    document.querySelectorAll(".art-reveal:not(.is-in)").forEach(function (el) { io.observe(el); });
  }
  if (document.readyState !== "loading") arm(); else document.addEventListener("DOMContentLoaded", arm);
  if (window.document$) window.document$.subscribe(arm);
})();
