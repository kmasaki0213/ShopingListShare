import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap"; // ✅ すべてのBootstrapコンポーネントを読み込む

export default class extends Controller {
  static targets = ["modal"]

  open() {
    const modal = new bootstrap.Modal(this.modalTarget); // ✅ `bootstrap.Modal` でインスタンス作成
    modal.show();
  }

  close() {
    const modal = bootstrap.Modal.getInstance(this.modalTarget); // ✅ `getInstance` で既存モーダル取得
    if (modal) { modal.hide(); }
  }
}
