class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.2/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "01c2ba3bb9c184cff9571a6d6577d34ddb46e44cf112275b7f9c61ef6ff61763"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.2/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "3b92e6c5876d3c489aad467677a5441aab53765ea23327353e8c02b17e0e82a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.2/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d30638ff40d510e0bb610ef0633b31e732e7385d977df1572a482bcf908173c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.2/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1469d804b674431e9351e57b03f9a4513a5eef320f523fa61cb48ba3cc5c9e22"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "git-ca" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-ca" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-ca" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-ca" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!
    man1.install "git-ca.1" if File.exist?("git-ca.1")

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files
    leftover_contents -= ["git-ca.1"]

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
