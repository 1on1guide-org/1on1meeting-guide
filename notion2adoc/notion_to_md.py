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
    filter_body = {
        "filter": {
            "property": "状態",
            "select": {
                "equals": "公開前"
            }
        }
    }
    response = requests.post(url, headers=headers, json=filter_body)
    response.raise_for_status()
    return response.json()["results"]

def get_item_properties(item):
    item_properties = {}
    for key, value in item["properties"].items():
        if value["type"] == "title":
            item_properties[key] = value["title"][0]["text"]["content"]
        elif value["type"] == "rich_text":
            item_properties[key] = value["rich_text"][0]["text"]["content"]
        elif value["type"] == "number":
            item_properties[key] = value["number"]
        elif value["type"] == "select":
            item_properties[key] = value["select"]["name"]
        elif value["type"] == "multi_select":
            item_properties[key] = [option["name"] for option in value["multi_select"]]
    return item_properties

def is_item_valid(item):
    required_keys = ["No.", "パターン名", "状態"]
    for key in required_keys:
        if key not in item:
            return False
    return True

def create_markdown_file(item):
    file_name = f"patterns/{item['No.']}.md"
    md_file = MdUtils(file_name=file_name)
    
    # レベル1のヘッダーを作成
    md_file.new_header(level=1, title=item["パターン名"])
    
    sections = [
        ("はじめに", "はじめに(サブタイトル的に内容を推測できるもの)"),
        ("要約", "要約(使用例を除く詳細をまとめ理解を促すもの)"),
        ("状況", "状況"),
        ("問題", "問題"),
        ("フォース", "フォース(問題に至る背景)"),
        ("使用例", "使用例(カードを切るタイミングや背景)"),
        ("関連パターン", "関連パターン")
    ]

    for section_title, property_name in sections:
        # レベル2のヘッダーを作成
        md_file.new_header(level=2, title=section_title)
        md_file.new_line(item[property_name])

    md_file.create_md_file()
    


if __name__ == "__main__":
    items = get_database_items()
    for item in items:
        item_properties = get_item_properties(item)
        if is_item_valid(item_properties) and item_properties["状態"] == "一般公開済":
            create_markdown_file(item_properties)
        else:
            print(f"Invalid item: {item_properties}")