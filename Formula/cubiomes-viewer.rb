class CubiomesViewer < Formula
  desc "Efficient graphical Minecraft seed finder and map viewer"
  homepage "https://github.com/Cubitect/cubiomes-viewer"
  url "https://github.com/Cubitect/cubiomes-viewer/releases/download/4.1.2/cubiomes-viewer-4.1.2-src.tar.gz"
  sha256 "fa8aa328b4bfbdd5df9474cc9bd13a121d4c93f5f45f2fd40a79a53d9ab42255"
  license "GPL-3.0-or-later"

  depends_on "qt@5"

  resource "logo_icon" do
    url "https://raw.githubusercontent.com/cacheci/cubiomes-viewer/c3ded058165912331d7f3f077423dc134601bab8/rc/icons/logo.icns"
    sha256 "73602322216cd14cca01b65465020c881879c71a40b1e210e3a23fddb16951a4"
  end

  def install
    resource("logo_icon").stage do
      (buildpath/"rc/icons").mkpath
      cp "logo.icns", buildpath/"rc/icons/logo.icns"
    end

    (buildpath/"cubiomes-viewer.pro").append_lines <<~EOS
      macx {
        ICON = ./rc/icons/logo.icns
      }
    EOS

    system "qmake", "CONFIG+=release"
    system "make"

    prefix.install "cubiomes-viewer.app" => "Cubiomes Viewer.app"
    bin.write_exec_script "#{prefix}/Cubiomes Viewer.app/Contents/MacOS/cubiomes-viewer"
  end

  def caveats
    <<~EOS
      By default, the Cubiomes Viewer.app is not linked into /Applications.
      You can link it manually, or run the following command to do so:
        ln -s "#{prefix}/Cubiomes Viewer.app" "/Applications/Cubiomes Viewer.app"
    EOS
  end
end
