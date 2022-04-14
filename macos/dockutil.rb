class Dockutil < Formula
  version "3.0.2"
  desc "Tool for managing dock items."
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/lotyp/homebrew-formulae/raw/master/bin/dockutil.#{version}.tar.gz"
  sha256 "0245e7df6bf3d35820f0fe4b6fa5bdd1d109fa304df4a740e11acdf78dde20d8"
  license "Apache-2.0"

  def install
    bin.install "dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
