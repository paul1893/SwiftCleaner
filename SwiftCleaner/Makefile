BUILD_PATH=.build
SWIFT_BUILD_FLAGS=--product SwiftCleaner --configuration release --disable-sandbox --scratch-path ${BUILD_PATH}

X86_64_PATH=$(shell swift build ${SWIFT_BUILD_FLAGS} --arch x86_64 --show-bin-path)
EXECUTABLE_X86_64="${X86_64_PATH}/SwiftCleaner"
BUNDLE_X86_64="${X86_64_PATH}/SwiftCleaner_SwiftCleaner.bundle"

ARM64_PATH=$(shell swift build ${SWIFT_BUILD_FLAGS} --arch arm64 --show-bin-path)
EXECUTABLE_ARM64="${ARM64_PATH}/SwiftCleaner"
BUNDLE_ARM64="${ARM64_PATH}/SwiftCleaner_SwiftCleaner.bundle"

EXECUTABLE=${BUILD_PATH}/SwiftCleaner
BUNDLE=${BUNDLE_ARM64}

clean:
	@swift package clean

build_x86_64:
	@swift build ${SWIFT_BUILD_FLAGS} --arch x86_64

build_arm64:
	@swift build ${SWIFT_BUILD_FLAGS} --arch arm64

build_release: clean build_x86_64 build_arm64
	@lipo -create -output ${EXECUTABLE} ${EXECUTABLE_X86_64} ${EXECUTABLE_ARM64}
	@strip -rSTX ${EXECUTABLE}

show_bin_path:
	@echo ${EXECUTABLE}

show_bundle_path:
	@echo ${BUNDLE}