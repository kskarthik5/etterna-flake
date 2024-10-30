{ stdenv, lib, fetchFromGitHub, cmake, nasm
, gtk2, glib, ffmpeg_4, alsa-lib, libmad, libogg, libvorbis
, glew, libpulseaudio, udev, openssl, doxygen, pkg-config
, libX11, libGLU, libGL, libXpm, libXext, libXxf86vm
}:

stdenv.mkDerivation {
  pname = "etterna";
  version = "0.73-dev";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo  = "etterna";
    rev   = "develop";
    sha256 = "sha256-LdJDTO8c7kS8G52b0MRO4oFhZZlcsexwJl1deVz9vf0=";
  };

  # patches = [
  #   ./0001-fix-build-with-ffmpeg-4.patch
  # ];

  # postPatch = ''
  #   sed '1i#include <ctime>' -i src/arch/ArchHooks/ArchHooks.h # gcc12
  # '';

  nativeBuildInputs = [ cmake nasm pkg-config ];

  buildInputs = [
    gtk2 glib ffmpeg_4 alsa-lib libmad libogg libvorbis
    glew libpulseaudio udev openssl doxygen
     libX11 libGLU libGL libXpm libXext libXxf86vm
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DWITH_CRASHPAD=OFF"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/Etterna/Etterna $out/bin/Etterna
  '';

  meta = with lib; {
    homepage = "https://www.etterna.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = [ ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
