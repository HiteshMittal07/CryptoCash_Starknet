import { AwesomeQR } from "awesome-qr";
export async function CreateTicketQR(noteString: string) {
  const buffer = await new AwesomeQR({
    text: noteString,
    size: 500,
  }).draw();
  return buffer;
}
