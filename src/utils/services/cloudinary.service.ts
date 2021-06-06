export class Cloudinary {
  static async uploadSingle(image: Express.Multer.File) {
    return `https://localhost:9000/${image.filename}`
  }
}
