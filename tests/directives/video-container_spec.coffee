describe "Video Container Directive", ->
  $compile = undefined
  $rootScope = undefined
  $sce = undefined
  element = undefined
  isoScope = undefined

  beforeEach module("walletApp")

  beforeEach inject((_$compile_, _$rootScope_, _$sce_, Wallet) ->

    $compile = _$compile_
    $rootScope = _$rootScope_
    $sce = _$sce_

    return
  )

  beforeEach ->
    element = $compile("<video-container img='img/blockchain-ad-placeholder.jpg' src='my.video.mp4'></video-container>")($rootScope)
    $rootScope.$digest()
    isoScope = element.isolateScope()
    isoScope.$digest()

  it "should have an image", ->
    expect(isoScope.img).toBeDefined()

  it "should have a video src", ->
    expect(isoScope.src).toBeDefined()

  it "should toggle play and pause", ->
    isoScope.playing = false
    isoScope.toggle()
    expect(isoScope.playing).toBe(true)

  it "should trust the video src", ->
    spyOn(isoScope, "trust")
    isoScope.load()
    expect(isoScope.trust).toHaveBeenCalled()
