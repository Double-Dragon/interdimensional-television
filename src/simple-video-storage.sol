pragma solidity ^0.4.0;

contract SimpleVideoStorage {

    Video[] public playlist;
    uint16 public maxVideoRuntime;
    uint8 public maxPlaylistLength;
    uint256 public lastPlaylistUpdate;
    
    function SimpleVideoStorage() {
        maxVideoRuntime = 2000;
        maxPlaylistLength = 5;
    }
    
    struct Video {
        bytes16 videoId;
        uint16 videoLength;
    }
    

    // NOTE: solidity does not allow emitting of structs
    // playlist has an implicit tuple data structure
    // ids[0] => videoLengths[0]
    event EmitPlaylist(bytes16[5] ids, uint16[5] videoLengths);

    function submitVideo(bytes16 id, uint16 videoLength)
      updatePlaylist updateLastPlaylistTrigger availablePlaylist {
        playlist.push(Video(id, videoLength));
    }
    
    function calculatePlaylistShiftLength(uint256 elapsedTime) returns(uint16) {
        uint elapsedVideoTime;
        for (uint16 i = 0; elapsedTime < elapsedVideoTime && i <= maxPlaylistLength; i++) {
            elapsedVideoTime = elapsedVideoTime + playlist[i].videoLength;
        }
        return i;
    }
    
    function retrieveVideoLengths(Video[] playlist) internal returns(uint16[5] videoLengths) {
        uint16[5] memory videoIds;
        for (uint16 i = 0; i < maxPlaylistLength; i++) {
            videoIds[i] = playlist[i].videoLength;
        }
        return videoIds;
    }
    
    function retrieveIds(Video[] playlist) internal returns(bytes16[5] ids) {
        bytes16[5] memory videoIds;
        for (uint16 i = 0; i < maxPlaylistLength; i++) {
            videoIds[i] = playlist[i].videoId;
        }
        return videoIds;
    }
    
    function cleanPlaylist(uint16 index) internal {
        Video[5] memory newPlaylist; // does not allow Video[maxPlaylistLength]
        uint16 newPlaylistIndex;
        for (index; index < maxPlaylistLength; index++) {
            newPlaylist[newPlaylistIndex] = playlist[index];
            newPlaylistIndex++;
        }
        for (uint16 i = 0; i < maxPlaylistLength; i++) {
            playlist[i] = newPlaylist[i];
        }
    }
    
    modifier updateLastPlaylistTrigger() {
        lastPlaylistUpdate = now;
        _;
    }
    
    modifier updatePlaylist() {
        uint256 elapsedTime = now - lastPlaylistUpdate;
        uint16 playlistShiftLength = calculatePlaylistShiftLength(elapsedTime);
        // shift array # of times = current index of iteration
        cleanPlaylist(playlistShiftLength);
        _;
    }
    
    modifier availablePlaylist() {
        require(playlist.length < maxPlaylistLength);
        _;
    }
}
