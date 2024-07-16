import jsPDF from "jspdf";
export function downloadQRCodePDF(
  qrDataURL: any,
  denomination: any,
  tokenName: any
) {
  const pdf = new jsPDF();
  pdf.setFontSize(30);
  pdf.text("Crypto Cash", 65, 14);
  pdf.addImage(qrDataURL, "JPEG", 45, 20, 100, 100);
  pdf.setTextColor("#808080");
  pdf.text("https://cryptocash_starknet.netlify.app", 25, 140);
  pdf.setFontSize(23);
  pdf.text("Use the QR Code to withdraw the value.", 25, 130);
  pdf.text(`Value:${denomination} ${tokenName}`, 25, 150);
  pdf.text(`Network:Starknet`, 25, 160);
  pdf.save(`CryptoCash${denomination}ETH.pdf`);
}
