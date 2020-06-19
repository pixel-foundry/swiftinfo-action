FROM swift:5.2
LABEL maintainer "Pixel Foundry <hi@pixelfoundry.io>"

RUN apt-get update && apt-get install -y curl jq && \
	git clone --branch "master" https://github.com/pixel-foundry/SwiftInfo.git && \
	cd SwiftInfo && \
	swift build --configuration release --static-swift-stdlib && \
	mv `swift build --configuration release --static-swift-stdlib --show-bin-path`/swiftinfo /usr/bin && \
	mkdir /usr/include/swiftinfo && \
	cp -a `swift build --configuration release --static-swift-stdlib --show-bin-path`/. /usr/include/swiftinfo && \
	cd .. && \
	rm -rf SwiftInfo

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
