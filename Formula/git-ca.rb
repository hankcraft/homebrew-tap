class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.5/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "0454803415b3e0802c3fe79bc37883b2af4b80d11add461f83fc127799e35c29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.5/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "370e61c71e939d3b17755b5dd419283a161cd5d198a7f1b30aa0fa1834d9bdb2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.5/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56724a5f244da5a13d42b8b2f0592b4907337dc90528e15075b499e4c15615a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.5/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19b4927d4a380a5352b6dde758637faeae383f621e1bfa7dda81ebd2d2560e47"
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
