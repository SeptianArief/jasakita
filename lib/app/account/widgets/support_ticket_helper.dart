class SupportTicketHelper {
  removePTag(String message) {
    return message
        .replaceAll("<", "")
        .replaceAll("p", "")
        .replaceAll(">", "")
        .replaceAll("/", "");
  }
}
