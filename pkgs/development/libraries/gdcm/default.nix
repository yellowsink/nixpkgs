{ lib
, stdenv
, fetchFromGitHub
, cmake
, enableVTK ? true
, vtk_8
, ApplicationServices
, Cocoa
, enablePython ? false
, python ? null
, swig
}:

stdenv.mkDerivation rec {
  pname = "gdcm";
  version = "3.0.20";

  src = fetchFromGitHub {
    owner = "malaterre";
    repo = "GDCM";
    rev = "v${version}";
    sha256 = "sha256-MaQk2VlaZxZPNzVF9pUnEzMaXyN0tq2P3kodnGpl6PA=";
  };

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals enableVTK [
    "-DGDCM_USE_VTK=ON"
  ] ++ lib.optionals enablePython [
    "-DGDCM_WRAP_PYTHON:BOOL=ON"
    "-DGDCM_INSTALL_PYTHONMODULE_DIR=${placeholder "out"}/${python.sitePackages}"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals enableVTK [
    vtk_8
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Cocoa
  ] ++ lib.optionals enablePython [ swig python ];

  meta = with lib; {
    description = "The grassroots cross-platform DICOM implementation";
    longDescription = ''
      Grassroots DICOM (GDCM) is an implementation of the DICOM standard designed to be open source so that researchers may access clinical data directly.
      GDCM includes a file format definition and a network communications protocol, both of which should be extended to provide a full set of tools for a researcher or small medical imaging vendor to interface with an existing medical database.
    '';
    homepage = "https://gdcm.sourceforge.net/";
    license = with licenses; [ bsd3 asl20 ];
    maintainers = with maintainers; [ tfmoraes ];
  };
}
