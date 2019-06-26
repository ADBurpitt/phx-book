import { Presence } from 'phoenix'
import Player from './player'

let Video = {

  init(socket, element) {
    if (!element) return

    let playerId = element.getAttribute("data-player-id")
    let videoId = element.getAttribute("data-id")

    socket.connect()
    Player.init(element.id, playerId, () => this.onReady(videoId, socket))
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container")
    let msgInput = document.getElementById("msg-input")
    let postButton = document.getElementById("msg-submit")
    let userList = document.getElementById("user-list")
    let lastSeenId = 0
    let vidChannel = socket.channel(`videos:${videoId}`, () => ({ last_seen_id: lastSeenId }))
    let presence = new Presence(vidChannel)

    presence.onSync(() => {
      userList.innerHTML = presence.list((id, {user, metas: [first, ...rest]}) => {
        let count = rest.length + 1

        return `<li>${user.username}: (${count})</li>`
      }).join("")
    })

    postButton.addEventListener("click", e => {
      vidChannel
        .push("new_annotation", { body: msgInput.value, at: Player.getCurrentTime() })
        .receive("error", e => console.log(e))

      msgInput.value = ""
    })

    msgContainer.addEventListener("click", e => {
      e.preventDefault()
      let seconds = e.target.getAttribute("data-seek") || e.target.parentNode.getAttribute("data-seek")
      if (!seconds) return

      Player.seekTo(seconds)
    })

    vidChannel.on("new_annotation", res => lastSeenId = resp.id && this.renderAnnotation(msgContainer, res))
    vidChannel.join()
      .receive("ok", res => {
        let ids = res.annotations.map(a => a.id)
        if (ids.length > 0) lastSeenId = Math.max(...ids)
        this.scheduleMessages(msgContainer, res.annotations)
      })
      .receive("error", reason => console.error("join failed", reason))
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderAnnotation(msgContainer, { user, body, at }) {
    let template = document.createElement("div")

    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        [${this.formatTime(at)}]
        <b>${this.esc(user.username)}</b>:${this.esc(body)}
      </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  scheduleMessages(msgContainer, annotations) {
    clearTimeout(this.scheduleTimer)
    this.scheduleTimer = setTimeout(() => {
      let ctime = Player.getCurrentTime()
      let remaining = this.renderAtTime(annotations, ctime, msgContainer)
      this.scheduleMessages(msgContainer, remaining)
    }, 1000);
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter(a => a.at > seconds || (this.renderAnnotation(msgContainer, a) && false))
  },

  formatTime(at) {
    let date = new Date(null)
    date.setSeconds(at / 1000)
    return date.toISOString().substr(14, 5)
  }

}

export default Video