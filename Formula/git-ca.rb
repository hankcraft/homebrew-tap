class GitCa < Formula
  desc "git plugin that drafts commit messages using GitHub Copilot"
  homepage "https://github.com/hankcraft/git-ca"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.6/git-ca-aarch64-apple-darwin.tar.xz"
      sha256 "a013f4b3ed4ad623691b735e9f3a58cbc821cd7bc7d4e9ad74273465fa934913"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.6/git-ca-x86_64-apple-darwin.tar.xz"
      sha256 "09b86754aedf4cc3d780e8af50499216dbf5a95cfb8e0583d6974d36d934dec7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.6/git-ca-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f79cc77ceff768d4a414dcb5de717ea529244f9327507c5cf6ef6a41deb32fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hankcraft/git-ca/releases/download/v0.2.6/git-ca-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f416838ef5537616312349b809a4a213af254c1846a1124875135f60d896c3d0"
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
