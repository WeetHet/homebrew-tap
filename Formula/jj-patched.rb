class JjPatched < Formula
  desc "Jujutsu with .gitattributes EOL support and non-UTF-8 path fixes"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "6489f79d59dc4f9c11230c51d309dc9c6ec392921772b738546966c494b6d72c"
  license "Apache-2.0"

  depends_on "rust" => :build

  conflicts_with "jj", because: "both install a `jj` binary"

  patch do
    url "https://raw.githubusercontent.com/WeetHet/homebrew-tap/130d93de8b99f8fb6b81ea2c301cecebd989872a/patches/jj-patched/0002-gitattributes-cargo-lock.patch"
    sha256 "0f53a810733756fe148b106cf7df54f5d0d46141a5938db53927774754837418"
  end

  patch do
    url "https://raw.githubusercontent.com/WeetHet/homebrew-tap/130d93de8b99f8fb6b81ea2c301cecebd989872a/patches/jj-patched/0003-index-ignore-non-UTF-8-Git-paths-in-changed-path-ind.patch"
    sha256 "ffef0e1d4f461dadd6afd2e150860a1b8b06fd75e8daa6904001e24873db4091"
  end

  patch do
    url "https://raw.githubusercontent.com/WeetHet/homebrew-tap/130d93de8b99f8fb6b81ea2c301cecebd989872a/patches/jj-patched/0001-gitattributes-eol-support.patch"
    sha256 "ca11035d5893a7aa2c0684ed9b418046e25de3d17fcb46642b699ccbd1ab462c"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
