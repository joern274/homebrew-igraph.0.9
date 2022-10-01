class HomebrewIgraph09 < Formula
  desc "Homebrew access to download and build igraph 0.9.10"
  homepage "https://github.com/joern274/homebrew-igraph.0.9"
  url "https://github.com/joern274/homebrew-igraph.0.9/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "e1e51a77c1a8eade7a6360df7cfbf63009f49b5eb378246aa32bc065baf0e884"
  license "GNU GPL v2.0"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "igraph-0.9" do
    url "https://github.com/igraph/igraph/releases/download/0.9.10/igraph-0.9.10.tar.gz"
    sha256 "3e10eb2e0588bf6a2e1e730fb1a685f7591cbe589326f4ac1f5bb45b36664dbe"
  end

  def install
    build = buildpath/"build"
    resource("igraph-0.9").stage(buildpath) do |stage|
      stage.staging.retain!
      source = Dir.pwd
      mkdir(build) do
        system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DBUILD_SHARED_LIBS=1", "#{source}" 
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
  end

  test do
      # Adapted from http://igraph.org/c/doc/igraph-tutorial.html
      (testpath / "igraph_test.c").write <<-EOS
      #include <igraph.h>
      int main(void)
      {
          igraph_integer_t diameter;
          igraph_t graph;
          return 0;
      }
      EOS
    system ENV.cc, "igraph_test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-o", "igraph_test"
    system "./igraph_test"
  end
end
