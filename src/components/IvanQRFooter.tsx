import React from "react";

export const IvanQRFooter = () => {
  return (
    <footer className="mt-20 border-t border-gray-200 dark:border-gray-700 pt-10 pb-6 text-center space-y-8">


      {/* ☕ Donation / Support */}
      <div>
        <p className="text-gray-600 dark:text-gray-300 mb-3">
          ☕ Enjoy using IvanQR? Support future updates!
        </p>
        <a
          href="https://www.buymeacoffee.com/ivancreates"
          target="_blank"
          rel="noopener noreferrer"
          className="px-5 py-2 bg-[#FFDD00] rounded-lg font-semibold hover:scale-105 transition transform"
        >
          Buy Me a Coffee
        </a>
        {/* OR: Replace the link above with your GCash QR download */}
        {/* <a href="/gcash-qr.png" download className="px-5 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition">Donate via GCash</a> */}
      </div>

      {/* 💌 Email Subscription */}
      <form
        action="https://formsubmit.co/fernandezivan140@gmail.com"
        method="POST"
        className="mt-6 flex flex-col sm:flex-row justify-center gap-3 px-4"
      >
        <input
          type="email"
          name="email"
          placeholder="Enter your email for QR updates"
          className="px-4 py-2 rounded-lg border border-gray-300 focus:ring focus:ring-indigo-300 w-full sm:w-72"
          required
        />
        <button
          type="submit"
          className="px-5 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
        >
          Subscribe
        </button>
      </form>

      {/* 🧾 Footer Credits */}
      <div className="text-gray-500 dark:text-gray-400 text-sm mt-8">
        <p>
          © {new Date().getFullYear()} <span className="font-semibold">IvanQR</span> —
          Built with 💙 by Ivan Creates.
        </p>
        <p className="mt-1">
          Hosted on <a href="https://www.netlify.com/" target="_blank" rel="noopener noreferrer" className="text-indigo-500 hover:underline">Netlify</a>
        </p>
      </div>
    </footer>
  );
};