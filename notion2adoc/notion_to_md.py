import os
import requests
from mdutils.mdutils import MdUtils

NOTION_API_KEY = os.environ["NOTION_API_KEY"]
NOTION_DATABASE_ID = os.environ["NOTION_DATABASE_ID"]

headers = {
    "Authorization": f"Bearer {NOTION_API_KEY}",
    "Notion-Version": "2022-06-28",  # Notion APIのバージョンを最新に更新してください
    "Content-Type": "application/json",
}


def get_database_items():
    url = f"https://api.notion.com/v1/databases/{NOTION_DATABASE_ID}/query"
    filter_body = {}
    response = requests.post(url, headers=headers, json=filter_body)
    response.raise_for_status()
    return response.json()["results"]


def get_item_properties(item):
    item_properties = {}
    for key, value in item["properties"].items():
        if value["type"] == "title":
            item_properties[key] = value["title"][0]["text"]["content"] if value["title"] else ""
        elif value["type"] == "rich_text":
            item_properties[key] = value["rich_text"][0]["text"]["content"] if value["rich_text"] else ""
        elif value["type"] == "number":
            item_properties[key] = value["number"]
        elif value["type"] == "select":
            item_properties[key] = value["select"]["name"] if value["select"] else ""
        elif value["type"] == "multi_select":
            item_properties[key] = [option["name"]
                                    for option in value["multi_select"]] if value["multi_select"] else []
        elif value["type"] == "date":
            item_properties[key] = value["date"]["start"] if value["date"] else ""
        elif value["type"] == "files":
            item_properties[key] = [file["name"]
                                    for file in value["files"]] if value["files"] else []
        elif value["type"] == "checkbox":
            item_properties[key] = value["checkbox"]
        elif value["type"] == "url":
            item_properties[key] = value["url"] if value["url"] else ""
        elif value["type"] == "email":
            item_properties[key] = value["email"] if value["email"] else ""
        elif value["type"] == "phone_number":
            item_properties[key] = value["phone_number"] if value["phone_number"] else ""
        elif value["type"] == "formula":
            item_properties[key] = value["formula"]["string"] if "string" in value["formula"] else value["formula"]["number"]
        elif value["type"] == "relation":
            item_properties[key] = [related_item["id"]
                                    for related_item in value["relation"]] if value["relation"] else []
        elif value["type"] == "rollup":
            item_properties[key] = value["rollup"]["value"] if value["rollup"] else ""
        # ... 他のプロパティタイプも必要に応じて追加
        else:
            item_properties[key] = ""

    return item_properties


def is_item_valid(item):
    required_keys = ["No.", "パターン名", "状態"]
    for key in required_keys:
        if key not in item:
            return False
    return True

def create_id_to_pattern_name_map(items):
    id_to_pattern_name = {}
    for item in items:
        item_properties = get_item_properties(item)
        id_to_pattern_name[item["id"]] = item_properties["パターン名"]
    return id_to_pattern_name


def create_markdown_file(item, id_to_pattern_name):
    file_name = f"patterns/{item['No.']}.md"
    md_file = MdUtils(file_name=file_name)

    # レベル1のヘッダーを作成
    md_file.new_header(level=1, title=item["パターン名"])

    section_mapping = {
        "はじめに": "はじめに(サブタイトル的に内容を推測できるもの)",
        "要約": "要約(使用例を除く詳細をまとめ理解を促すもの)",
        "状況": "状況",
        "問題": "問題",
        "フォース": "フォース(問題に至る背景)",
        "使用例": "使用例(カードを切るタイミングや背景)",
        "関連パターン": "関連パターン"
    }

    for section_title, property_name in section_mapping.items():
        md_file.new_line(f"")
        md_file.new_line(f"{section_title}")
        if property_name == "関連パターン":
            related_pattern_names = [id_to_pattern_name[related_id] for related_id in item_properties[property_name]]
            md_file.new_line(', '.join(related_pattern_names))
        elif isinstance(item_properties[property_name], list):
            md_file.new_line(f": {', '.join(item_properties[property_name])}")
        else:
            md_file.new_line(f": {item_properties[property_name]}")

    md_file.create_md_file()


if __name__ == "__main__":
    items = get_database_items()
    for item in items:
        item_properties = get_item_properties(item)
        if is_item_valid(item_properties):
            create_markdown_file(item_properties)
        else:
            print(f"Invalid item: {item_properties}")
