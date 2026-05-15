import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Standalone output for Docker deployment
  output: 'standalone',

  // Disable StrictMode to prevent double useEffect in development
  reactStrictMode: false,

  // Enable gzip/brotli compression in production
  compress: true,

  // Allow next/image to load from external domains
  images: {
    remotePatterns: [
      { protocol: "https", hostname: "**" },
      { protocol: "http", hostname: "localhost" },
      { protocol: "http", hostname: "127.0.0.1" },
    ],
  },

  // Experimental optimizations
  experimental: {
    optimizeCss: true,
  },

  // Skip ESLint and TypeScript errors during production builds
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
};

export default nextConfig;
