import { useState } from "react";
import { QRCodeSVG } from "qrcode.react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Download, RefreshCw, QrCode } from "lucide-react";
import { toast } from "sonner";

export const QRGenerator = () => {
  const [inputValue, setInputValue] = useState("");
  const [qrValue, setQrValue] = useState("");
  const [qrSize, setQrSize] = useState(256);

  const generateQR = () => {
    if (!inputValue.trim()) {
      toast.error("Please enter some text or URL");
      return;
    }
    setQrValue(inputValue);
    toast.success("QR Code generated successfully!");
  };

  const downloadQR = () => {
    if (!qrValue) {
      toast.error("Generate a QR code first");
      return;
    }

    const svg = document.getElementById("qr-code-svg");
    if (!svg) return;

    const svgData = new XMLSerializer().serializeToString(svg);
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");
    const img = new Image();

    canvas.width = qrSize;
    canvas.height = qrSize;

    img.onload = () => {
      ctx?.drawImage(img, 0, 0);
      canvas.toBlob((blob) => {
        if (blob) {
          const url = URL.createObjectURL(blob);
          const link = document.createElement("a");
          link.href = url;
          link.download = "qrcode.png";
          link.click();
          URL.revokeObjectURL(url);
          toast.success("QR Code downloaded!");
        }
      });
    };

    img.src = "data:image/svg+xml;base64," + btoa(unescape(encodeURIComponent(svgData)));
  };

  const resetForm = () => {
    setInputValue("");
    setQrValue("");
    toast.info("Form cleared");
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-background via-background to-muted">
      <div className="w-full max-w-4xl">
        <div className="text-center mb-8 animate-fade-in">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-accent mb-4 shadow-lg">
            <QrCode className="w-8 h-8 text-primary-foreground" />
          </div>
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
            IvanQR
          </h1>
          <p className="text-muted-foreground text-lg">
            Create professional QR codes instantly
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          <Card className="border-border shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-hover)] transition-all duration-300">
            <CardHeader>
              <CardTitle>Generator</CardTitle>
              <CardDescription>Enter your text or URL below</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="input">Text or URL</Label>
                <Input
                  id="input"
                  placeholder="Enter text or paste URL..."
                  value={inputValue}
                  onChange={(e) => setInputValue(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && generateQR()}
                  className="border-input focus-visible:ring-primary"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="size">QR Code Size: {qrSize}px</Label>
                <input
                  id="size"
                  type="range"
                  min="128"
                  max="512"
                  step="64"
                  value={qrSize}
                  onChange={(e) => setQrSize(Number(e.target.value))}
                  className="w-full h-2 bg-secondary rounded-lg appearance-none cursor-pointer accent-primary"
                />
              </div>

              <div className="flex gap-3">
                <Button 
                  onClick={generateQR} 
                  className="flex-1 bg-gradient-to-r from-primary to-accent hover:opacity-90 transition-opacity"
                >
                  Generate QR
                </Button>
                <Button 
                  onClick={resetForm} 
                  variant="outline"
                  size="icon"
                  className="border-border hover:bg-secondary"
                >
                  <RefreshCw className="w-4 h-4" />
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card className="border-border shadow-[var(--shadow-card)] hover:shadow-[var(--shadow-hover)] transition-all duration-300">
            <CardHeader>
              <CardTitle>Preview</CardTitle>
              <CardDescription>Your generated QR code</CardDescription>
            </CardHeader>
            <CardContent className="flex flex-col items-center justify-center space-y-6 min-h-[300px]">
              {qrValue ? (
                <>
                  <div className="p-6 bg-white rounded-2xl shadow-md">
                    <QRCodeSVG
                      id="qr-code-svg"
                      value={qrValue}
                      size={qrSize}
                      level="H"
                      includeMargin
                    />
                  </div>
                  <Button 
                    onClick={downloadQR}
                    variant="outline"
                    className="w-full border-primary text-primary hover:bg-primary hover:text-primary-foreground transition-all"
                  >
                    <Download className="w-4 h-4 mr-2" />
                    Download PNG
                  </Button>
                </>
              ) : (
                <div className="text-center text-muted-foreground">
                  <QrCode className="w-16 h-16 mx-auto mb-3 opacity-20" />
                  <p>Your QR code will appear here</p>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};
