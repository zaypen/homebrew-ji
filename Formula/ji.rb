class Ji < Formula
  desc "Voice dictation as a Unix pipe: 16 kHz mono PCM in, words out"
  homepage "https://github.com/zaypen/ji"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/zaypen/ji/releases/download/v0.1.1/ji-aarch64-apple-darwin.tar.xz"
    sha256 "e5df7a483ff40578288b20465a47593d985a354e39ccf5173bcba0430b1ddfc8"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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
      bin.install "ji", "ji-dictate"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
