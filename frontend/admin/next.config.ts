import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Subdomain deployment — no basePath needed
  // Serve admin under basePath if specified (e.g., '/admin'), otherwise no basePath
  basePath: process.env.NEXT_PUBLIC_BASE_PATH ? process.env.NEXT_PUBLIC_BASE_PATH : undefined,
  trailingSlash: true,

  // Standalone output for Docker deployment
  output: 'standalone',

  // Disable StrictMode to prevent double useEffect in development
  // (causes duplicate API calls and double error toasts)
  reactStrictMode: false,

  // Ignore ESLint errors during Docker builds to speed up the process
  eslint: {
    ignoreDuringBuilds: true,
  },

  // React Compiler (already enabled)
  reactCompiler: true,

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
    optimizePackageImports: ['lucide-react', 'react-icons'],
  },

  // Skip ESLint and TypeScript errors during production builds
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },

  async redirects() {
    return [
      {
        source: '/',
        destination: '/login',
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
