class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.3/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "0b9f65340ad7581c650eabb696652886c2943fc6b45cd2abc87daeadd2b0b10c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.3/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "b2c789f0afed808510fb330632113bac0305c1c14bfb9b1c94ba29210ffb4008"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.3/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c5124ba9211ddde817d80e7d6cb4c222f8df1a66b23907dea3d4cffd3e39496"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.3/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d98e33be3ad351c7747eed47663354733ab416586cf8e43d39694b7fae893eb5"
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
