# Testing Instructions for Hierarchical Layer Groups

## Quick Test

1. **Open the application:**
   ```
   http://localhost:1234/?proyecto=ecoreservas
   ```

2. **Open the Layer Control Panel:**
   - Click on the layers icon (usually in the top-right or left sidebar)
   - The accordion should display with hierarchical structure

3. **Expected Structure:**

   ```
   📁 Ecoregión relacionada a la Ecoreserva San Antero (Yellow header - bg-warning)
      📁 Inversión 1% (Green header - bg-success)
         📁 Preservación (Default header)
            ☐ Todos los enfoques de costos-Inversión no menos
            ☐ Costos de oportunidad-Inversión en compensación
            ☐ Costos ecológicos-Inversión en compensación
         📁 Restauración (Default header)
            ☐ [layers...]
         📁 Uso Sostenible (Default header)
            ☐ [layers...]
      📁 Inversión Voluntaria (Green header - bg-success)
         📁 Preservación (Default header)
            ☐ [layers...]
         📁 Restauración (Default header)
            ☐ [layers...]
         📁 Uso Sostenible (Default header)
            ☐ [layers...]
      📁 Compensación (Green header - bg-success)
         📁 [subgroups...]
   ```

## Verification Checklist

- [ ] Page loads without JavaScript errors
- [ ] Layer control panel opens when clicked
- [ ] Hierarchical structure displays correctly
- [ ] Top-level groups have yellow headers (bg-warning)
- [ ] Second-level groups have green headers (bg-success)
- [ ] Third-level groups have default styling
- [ ] Groups can be expanded/collapsed
- [ ] Layer checkboxes are visible
- [ ] Clicking checkboxes toggles layer visibility on map
- [ ] Metadata links (if present) open GeoNetwork catalog
- [ ] Ecoreservas logo appears next to layers

## Troubleshooting

### If you see module import errors:
1. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
2. Check browser console for specific error messages
3. Verify Parcel dev server is running: `ps aux | grep parcel`
4. Restart Parcel if needed

### If layers don't appear:
1. Check browser console for API errors
2. Verify backend is running: `curl http://localhost:8001/api/projects/by-name/ecoreservas/`
3. Check that layer data exists in backend
4. Verify GeoServer is accessible

### If structure looks wrong:
1. Check backend data structure via API
2. Verify `parent_group` relationships are correct
3. Check `orden` field for proper sorting
4. Review browser console for rendering errors

## Browser Console Commands

Open browser console (F12) and run:

```javascript
// Check if hierarchical tree was built
console.log('Accordion element:', document.getElementById('accordion'));

// Check project data
console.log('Current project:', window.currentProject);

// Check layer groups
const accordion = document.getElementById('accordion');
console.log('Number of cards:', accordion.querySelectorAll('.card').length);

// Check for errors
console.log('Check console for any errors above');
```

## API Verification

Test the API directly:

```bash
# Get project data with hierarchical structure
curl -s http://localhost:8001/api/projects/by-name/ecoreservas/ | python3 -m json.tool | less

# Check for nested subgroups
curl -s http://localhost:8001/api/projects/by-name/ecoreservas/ | python3 -m json.tool | grep -A 5 "subgroups"
```

## Success Criteria

✅ The implementation is successful if:
1. No JavaScript errors in console
2. Hierarchical structure matches production
3. All groups and layers are visible
4. Layer toggles work correctly
5. Styling matches production (yellow → green → default)
6. Collapse/expand functionality works
7. Metadata links work (if present)

## Known Issues

1. **Backend Data Duplicates:** Some groups appear multiple times due to incorrect parent_group assignments. This is a data issue, not a code issue.

2. **Module Import Fixed:** The circular dependency with `layers.js` has been resolved by getting `proyecto` from URL params instead.

3. **Backward Compatibility:** Other projects (non-ecoreservas) still use the legacy tree builder.

## Next Steps After Testing

1. If successful, clean up backend data to remove duplicates
2. Consider migrating other projects to hierarchical structure
3. Add unit tests for hierarchical rendering
4. Document the hierarchical structure in user guide
