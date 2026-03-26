import { describe, it, expect } from "vitest";
import { readFileSync, existsSync, statSync, readdirSync } from "fs";
import { join, resolve } from "path";

const ROOT = resolve(__dirname, "..");
const MARKETPLACE_PATH = join(ROOT, ".claude-plugin", "marketplace.json");

function readJson(path: string) {
  return JSON.parse(readFileSync(path, "utf-8"));
}

function extractFrontmatter(content: string): Record<string, string> | null {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;
  const fields: Record<string, string> = {};
  for (const line of match[1].split("\n")) {
    const idx = line.indexOf(":");
    if (idx > 0) {
      const key = line.slice(0, idx).trim();
      const val = line.slice(idx + 1).trim();
      if (key && val) fields[key] = val;
    }
  }
  return fields;
}

describe("marketplace.json", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  it("has required top-level fields", () => {
    expect(marketplace.name).toBeDefined();
    expect(marketplace.plugins).toBeInstanceOf(Array);
    expect(marketplace.plugins.length).toBeGreaterThan(0);
  });

  it("each plugin has name, source, and description", () => {
    for (const plugin of marketplace.plugins) {
      expect(plugin.name).toBeDefined();
      expect(plugin.source).toBeDefined();
      expect(plugin.description).toBeDefined();
    }
  });

  it("each plugin source path starts with ./", () => {
    for (const plugin of marketplace.plugins) {
      if (typeof plugin.source === "string") {
        expect(plugin.source).toMatch(/^\.\//);
      }
    }
  });

  it("each plugin source directory exists", () => {
    for (const plugin of marketplace.plugins) {
      if (typeof plugin.source === "string") {
        const pluginDir = join(ROOT, plugin.source);
        expect(existsSync(pluginDir), `Missing: ${pluginDir}`).toBe(true);
        expect(statSync(pluginDir).isDirectory(), `Not a directory: ${pluginDir}`).toBe(true);
      }
    }
  });
});

describe("plugin.json", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  for (const entry of marketplace.plugins) {
    if (typeof entry.source !== "string") continue;
    const pluginDir = join(ROOT, entry.source);

    describe(`plugin: ${entry.name}`, () => {
      const pluginJsonPath = join(pluginDir, ".claude-plugin", "plugin.json");

      it("has .claude-plugin/plugin.json", () => {
        expect(existsSync(pluginJsonPath), `Missing: ${pluginJsonPath}`).toBe(true);
      });

      it("plugin.json has required name field", () => {
        const pluginJson = readJson(pluginJsonPath);
        expect(pluginJson.name).toBeDefined();
      });
    });
  }
});

describe("hooks", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  for (const entry of marketplace.plugins) {
    if (typeof entry.source !== "string") continue;
    const pluginDir = join(ROOT, entry.source);
    const hooksJsonPath = join(pluginDir, "hooks", "hooks.json");

    if (!existsSync(hooksJsonPath)) continue;

    describe(`plugin: ${entry.name}`, () => {
      const hooksJson = readJson(hooksJsonPath);

      it("hooks.json has hooks object", () => {
        expect(hooksJson.hooks).toBeDefined();
        expect(typeof hooksJson.hooks).toBe("object");
      });

      it("hook handler scripts exist and are executable", () => {
        for (const [, matchers] of Object.entries(hooksJson.hooks)) {
          for (const matcher of matchers as any[]) {
            for (const hook of matcher.hooks ?? []) {
              if (hook.type === "command" && hook.command) {
                const cmd = hook.command.replace("${CLAUDE_PLUGIN_ROOT}", pluginDir);
                expect(existsSync(cmd), `Missing handler: ${cmd}`).toBe(true);
                const mode = statSync(cmd).mode;
                expect(mode & 0o111, `Not executable: ${cmd}`).toBeGreaterThan(0);
              }
            }
          }
        }
      });
    });
  }
});

describe("skills", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  for (const entry of marketplace.plugins) {
    if (typeof entry.source !== "string") continue;
    const pluginDir = join(ROOT, entry.source);
    const skillsDir = join(pluginDir, "skills");

    if (!existsSync(skillsDir)) continue;

    for (const skillName of readdirSync(skillsDir)) {
      const skillPath = join(skillsDir, skillName, "SKILL.md");
      if (!existsSync(skillPath)) continue;

      describe(`skill: ${skillName}`, () => {
        const content = readFileSync(skillPath, "utf-8");

        it("has valid YAML frontmatter with name and description", () => {
          const fm = extractFrontmatter(content);
          expect(fm, "Missing frontmatter").not.toBeNull();
          expect(fm!.name, "Missing name in frontmatter").toBeDefined();
          expect(fm!.description, "Missing description in frontmatter").toBeDefined();
        });
      });
    }
  }
});

describe("commands", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  for (const entry of marketplace.plugins) {
    if (typeof entry.source !== "string") continue;
    const pluginDir = join(ROOT, entry.source);
    const commandsDir = join(pluginDir, "commands");

    if (!existsSync(commandsDir)) continue;

    for (const file of readdirSync(commandsDir).filter((f) => f.endsWith(".md"))) {
      describe(`command: ${file}`, () => {
        const content = readFileSync(join(commandsDir, file), "utf-8");

        it("has valid YAML frontmatter with description", () => {
          const fm = extractFrontmatter(content);
          expect(fm, "Missing frontmatter").not.toBeNull();
          expect(fm!.description, "Missing description in frontmatter").toBeDefined();
        });
      });
    }
  }
});

describe("agents", () => {
  const marketplace = readJson(MARKETPLACE_PATH);

  for (const entry of marketplace.plugins) {
    if (typeof entry.source !== "string") continue;
    const pluginDir = join(ROOT, entry.source);
    const agentsDir = join(pluginDir, "agents");

    if (!existsSync(agentsDir)) continue;

    for (const file of readdirSync(agentsDir).filter((f) => f.endsWith(".md"))) {
      describe(`agent: ${file}`, () => {
        const content = readFileSync(join(agentsDir, file), "utf-8");

        it("has valid YAML frontmatter with name, description, and tools", () => {
          const fm = extractFrontmatter(content);
          expect(fm, "Missing frontmatter").not.toBeNull();
          expect(fm!.name, "Missing name in frontmatter").toBeDefined();
          expect(fm!.description, "Missing description in frontmatter").toBeDefined();
          expect(fm!.tools, "Missing tools in frontmatter").toBeDefined();
        });
      });
    }
  }
});
