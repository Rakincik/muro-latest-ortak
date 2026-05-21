import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Serve admin under /admin/ path for single-domain setup
  basePath: '/admin',

  // Standalone output for Docker deployment
  output: 'standalone',

  // Disable StrictMode to prevent double useEffect in development
  // (causes duplicate API calls and double error toasts)
  reactStrictMode: false,

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
