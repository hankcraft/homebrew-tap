class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.3.0/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "f2944f04268bf918083c28d796be08aff1e2e48f8a4c21b63cce2cdcb1cd17c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.3.0/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "5328bf29e429af56870fac70f1db670753914cb58326ed29a1e6dddded5e82c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.3.0/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6777ff251c0240da0ecc0ee2bd83ab9146f3156ee56b141d79e6c76967fcba7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.3.0/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ff607a22303facf45a0f8994a5e7b8ea8fcbe22bb5ec586a725babc77866ecb"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-ca"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-ca"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-ca"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-ca"
    end

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
