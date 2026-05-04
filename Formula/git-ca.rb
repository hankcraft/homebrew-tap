class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.1/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "bb9ed4de1b867e020e6673311824f701efd7bf5af5af7fac3b311ef133cabe34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.1/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "6f533407727327c9a6796587e6e0542760b4db69bc68f246386b48e306f3fa0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.1/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5aceea98d0749527b46aebe80025c69526f3406edb2df26a1c8f8ef93841fc6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.1/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f0846f4ac7d505b77dadd5ac9f838fbdad4ee0c4060471d4351c3d44430c73d5"
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
