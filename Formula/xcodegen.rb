class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.33.0.tar.gz"
  sha256 "e05107f779c206cbacba0f2038f98cd1dc5cdc895324a76daec4b5168f119934"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  # bottle do
  #   cellar :any_skip_relocation
  #   sha256 "954d8df6e5e76c59471482dce21df05bed22382e30d1b5cc9bfa6e024508106c" => :big_sur
  #   sha256 "72a74170b8b457db6bce90da3daaa6520a24bef3d46d4dfbfd3599bfe45a8b5b" => :catalina
  #   sha256 "1d64fc7e6f3ade59a08eb9b9105c3b1d20d8d9cb4b4de2539590733fd203e014" => :mojave
  # end

  depends_on xcode: ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end