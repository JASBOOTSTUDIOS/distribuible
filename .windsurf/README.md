# Windsurf Context Configuration for Jasboot

This directory contains Windsurf IDE context configuration files that customize Cascade AI behavior for the Jasboot programming language project.

## 📁 Structure

```
.windsurf/
├── README.md           # This file
└── rules/              # Rule files for specific contexts
    ├── vm-memory-safety.md      # VM memory safety rules
    ├── jasboot-language.md      # Language development rules
    └── jmn-memory-system.md     # Neural memory system rules
```

## 🎯 What This Does

The Windsurf context system teaches Cascade AI about:
- **Project architecture** - How Jasboot is structured
- **Memory safety rules** - Critical VM development patterns
- **Language conventions** - Spanish keywords and Jasboot syntax
- **JMN operations** - Neural memory system usage
- **Common pitfalls** - Known issues and solutions

## 📋 Context Files

### Root Level

#### `.windsurfrules`
- **Location**: Project root (`/jasboot/.windsurfrules`)
- **Activation**: Always active for entire project
- **Purpose**: General project rules and conventions
- **Contains**:
  - Project overview and mission
  - Technology stack
  - Directory structure
  - Naming conventions
  - Common problems and solutions
  - Build commands

#### `AGENTS.md`
- **Location**: Project root (`/jasboot/AGENTS.md`)
- **Activation**: Automatic (Windsurf 2026 standard)
- **Purpose**: Machine-readable project documentation
- **Contains**:
  - Technical architecture details
  - Core concepts and data structures
  - Critical rules for AI agents
  - Common issues with solutions
  - Quality checklist

### Rules Directory

#### `vm-memory-safety.md`
- **Activation**: `glob: "sdk-dependiente/jasboot-ir/**/*.c"`
- **Priority**: 100 (highest)
- **Purpose**: Enforce memory safety in VM code
- **Key Rules**:
  - Always use `vm_leer_seguro()` / `vm_escribir_seguro()`
  - Overflow-safe bounds checking
  - JMN text synchronization
  - Error handling patterns

#### `jasboot-language.md`
- **Activation**: `glob: "**/*.jasb,sdk-dependiente/jas-compiler-c/**/*.c"`
- **Priority**: 90
- **Purpose**: Language development standards
- **Key Rules**:
  - Spanish keywords only (no English)
  - Type system conventions
  - JMN operations in Jasboot code
  - Code style guidelines

#### `jmn-memory-system.md`
- **Activation**: `glob: "sdk-dependiente/jasboot-jmn-core/**/*.c,**/*.jasb"`
- **Priority**: 95
- **Purpose**: Neural memory system development
- **Key Rules**:
  - Always close/consolidate JMN files
  - Text persistence patterns
  - Relation type usage
  - Search operation guidelines

## 🔧 How It Works

### Activation Modes

Windsurf rules support multiple activation modes:

1. **`always_on`**: Active for entire workspace (e.g., `.windsurfrules`)
2. **`glob`**: Active when file matches pattern (e.g., `**/*.jasb`)
3. **`model_decision`**: AI decides when to apply
4. **`manual`**: Activated via explicit command

### Priority System

Rules have priority values (0-100):
- **100**: VM Memory Safety (critical for correctness)
- **95**: JMN System (data persistence critical)
- **90**: Language Rules (code quality)

Higher priority rules take precedence when conflicts occur.

### Context Assembly

When Cascade processes a request, it assembles context from:

1. **Global Rules** (Windsurf settings)
2. **`.windsurfrules`** (project-level, always active)
3. **`AGENTS.md`** (automatic, location-based)
4. **Specific rule files** (based on glob pattern match)
5. **Memories** (auto-generated during conversations)
6. **Active editor state** (current file, selection)

## 🚀 Usage

### For Developers

When working on Jasboot:

1. **VM Code** (`sdk-dependiente/jasboot-ir/*.c`)
   - Memory safety rules automatically active
   - Use safe wrappers for all memory access
   - Validate bounds before operations

2. **Compiler Code** (`sdk-dependiente/jas-compiler-c/*.c`)
   - Language rules automatically active
   - Follow Spanish keyword conventions
   - Maintain type system consistency

3. **Jasboot Code** (`*.jasb` files)
   - Language rules guide syntax
   - JMN operations documented
   - Examples and patterns available

4. **JMN Core** (`jasboot-jmn-core/**/*.c`)
   - Neural memory rules active
   - Text persistence patterns enforced
   - Connection management guidelines

### For AI Agents (Cascade)

Cascade automatically:
- Loads relevant rules based on file being edited
- Applies memory safety checks for VM code
- Enforces Spanish keywords in Jasboot code
- Suggests correct JMN patterns
- Warns about common pitfalls

## 📝 Maintaining Context Files

### When to Update

Update context files when:
- Adding new language features
- Discovering new bug patterns
- Changing architecture
- Adding new APIs or functions
- Team conventions evolve

### How to Update

1. **Identify the right file**:
   - General project info → `.windsurfrules`
   - Architecture/concepts → `AGENTS.md`
   - VM-specific rules → `rules/vm-memory-safety.md`
   - Language-specific → `rules/jasboot-language.md`
   - JMN-specific → `rules/jmn-memory-system.md`

2. **Edit the file** directly (they're just Markdown)

3. **Test the change**:
   - Open a relevant file
   - Ask Cascade about the topic
   - Verify it references the new rule

4. **Commit to Git** (rules are version-controlled)

### Best Practices

- **Be specific**: "Use `vm_leer_seguro()`" > "Be safe"
- **Show examples**: Code snippets > descriptions
- **Explain why**: Help AI understand reasoning
- **Mark critical**: Use ✅/❌ for do/don't patterns
- **Keep updated**: Remove obsolete rules
- **Test changes**: Verify Cascade behavior

## 🔍 Debugging Context

### Check Active Rules

To see which rules are active:
1. Open Cascade panel
2. Click "Customizations" icon (top-right)
3. Select "Rules" tab
4. View active rules for current file

### Verify Rule Matching

If a rule isn't applying:
1. Check the `glob` pattern in frontmatter
2. Verify file path matches pattern
3. Check `activation` mode
4. Ensure priority isn't overridden

### Test Rule Content

To test if Cascade understands a rule:
1. Open a file matching the glob
2. Ask Cascade: "What are the memory safety rules for VM?"
3. Verify response matches rule file content

## 📚 References

### Official Documentation
- [Windsurf Docs](https://docs.windsurf.com)
- [Cascade Memories & Rules](https://docs.windsurf.com/windsurf/cascade/memories)
- [AGENTS.md Specification](https://docs.windsurf.com/windsurf/cascade/agents-md)

### Related Standards
- **AGENTS.md**: Emerging standard for AI agent context (2026)
- **Cursor Rules**: Similar system in Cursor IDE (`.cursorrules`)
- **Claude Skills**: Similar concept in Claude Code (`CLAUDE.md`)

### Jasboot Resources
- [Language Spec](../jasboot.md)
- [VM Documentation](../sdk-dependiente/jasboot-ir/README.md)
- [JMN Documentation](../sdk-dependiente/jasboot-jmn-core/README.md)

## 🆘 Getting Help

### For Cascade Issues
1. Check if rule file exists for your context
2. Verify glob pattern matches current file
3. Try reloading Windsurf window
4. Check global rules aren't conflicting

### For Jasboot Development
1. Consult `.windsurfrules` for general guidance
2. Check `AGENTS.md` for architecture details
3. Review specific rule files for detailed patterns
4. Ask Cascade: "What rules apply to this file?"

## ✅ Quality Checklist

Before committing context changes:

- [ ] Markdown syntax is valid
- [ ] Code examples compile/run
- [ ] Patterns are actually used in codebase
- [ ] Critical rules marked clearly (✅/❌)
- [ ] Glob patterns tested
- [ ] No contradictions with other rules
- [ ] Cascade can reference the new content

---

**Last Updated**: 2026-04-20  
**Project Version**: 0.0.1 (Beta)  
**Maintainer**: Jefry Astacio (@JASBOOTSTUDIOS)