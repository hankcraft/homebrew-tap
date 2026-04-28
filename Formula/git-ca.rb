class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.1.0/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "ee82fbba2eb3948f81917d11d4942b83e105d5055bf0058892f3be7a792e4c66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.1.0/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "fd48016b60dc9b83db0275e91a81547cee0bd7aedb9acca6b7ae27de30d4a832"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.1.0/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0d607e9ca4d5b1b8c10255417ad6bc003f001b16f2152536620887c26b9ba43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.1.0/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a68fb1b584783c6afa00c77cd208f4ee9c6ce0f96b91c899bb78d6418052e3a0"
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
